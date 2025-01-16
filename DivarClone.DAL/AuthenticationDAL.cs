using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Threading.Tasks;
using Shared;
using static System.Net.Mime.MediaTypeNames;
using System.Security.Authentication;

namespace DivarClone.DAL
{
    public class UserDTO
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Username { get; set; }

        public string Password { get; set; }

        public string Email { get; set; }

        public string PhoneNumber { get; set; }

        public string Role { get; set; }

        public List<string> Permissions { get; set; } 
    }

    // this is for scalability if we have a huge number of users
    // instead of querying a full preset role permission per user, we cache the preset data and join in application since it rarely changes.
    // the cache should update per change too with a db flag
    public static class PermissionCacheManager
    {
        public static Dictionary<string, List<string>> RolePermissionsCache { get; private set; } = new Dictionary<string, List<string>>();

        public static void SetRolePermissions(Dictionary<string, List<string>> rolePermissions)
        {
            RolePermissionsCache = rolePermissions;
        }

        public static void LoadRolePermissions(string connectionString)
        {
            using (var con = new SqlConnection(connectionString))
            {
                var cmd = new SqlCommand("[Authorize].[SP_GetRolesAndPermissions]", con)
                {
                    CommandType = CommandType.StoredProcedure
                };

                con.Open();

                using (var rdr = cmd.ExecuteReader())
                {
                    RolePermissionsCache = new Dictionary<string, List<string>>();

                    while (rdr.Read())
                    {
                        var roleName = rdr["RoleName"].ToString();

                        var permissions = rdr["Permissions"].ToString().Split(',');

                        if (!RolePermissionsCache.ContainsKey(roleName))
                        {
                            RolePermissionsCache[roleName] = new List<string>();
                        }

                        foreach (var permission in permissions)
                        {
                            RolePermissionsCache[roleName].Add(permission.Trim());
                        }
                    }
                }
            }
        }
    }

    public interface IAuthenticationDAL
    {
        bool SignUserUp(UserDTO userDTO);

        UserDTO AuthenticateUser(string email, string password);

        bool AssignUserRole(int userId, string roleName, bool updateExistingRole = false);

        Task<bool> GiveUserSpecialPermission(int userId, string permissionName);

        Task<bool> RemoveUserSpecialPermission(int userId, string permissionName);
    }

    public class AuthenticationDAL : IAuthenticationDAL
    {
        public string Constr { get; set; }
        public SqlConnection con;
        private readonly string _connectionString;

        public AuthenticationDAL(string connectionString)
        {
            con = new SqlConnection(Constr);
            _connectionString = connectionString;
            Constr = _connectionString;
        }

        public bool SignUserUp(UserDTO userDTO)
        {
            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("[Enrollement].[SP_SignUserDetailsUp]", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@FirstName", userDTO.Name);
                    cmd.Parameters.AddWithValue("@Password", userDTO.Password);
                    cmd.Parameters.AddWithValue("@Email", userDTO.Email);
                    cmd.Parameters.AddWithValue("@Phone", userDTO.PhoneNumber);
                    cmd.Parameters.AddWithValue("@Username", userDTO.Username);

                    SqlDataReader rdr = cmd.ExecuteReader();

                    if (rdr.Read()) {

                        AssignUserRole(Convert.ToInt32(rdr["Id"]), roleName:"RegularUser");

                        return true;
                    }
                    else
                    {
                        return false;
                    }

                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");

                    return false;
                }
            }
        }

        public UserDTO AuthenticateUser(string email, string password)
        {
            var userDTO = new UserDTO();

            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("[Enrollement].[SP_AuthenticateUser]", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    SqlDataReader rdr = cmd.ExecuteReader();

                    if (rdr.Read()) // if evaluation success
                    {
                        userDTO.Id = Convert.ToInt32(rdr["Id"]);
                        userDTO.Name = rdr["FirstName"].ToString();
                        userDTO.Username = rdr["Username"].ToString();
                        userDTO.Email = rdr["Email"].ToString();
                        userDTO.PhoneNumber = rdr["Phone"].ToString();
                        userDTO.Role = rdr["RoleName"].ToString();

                        var permissions = rdr["Permissions"].ToString().Split(',');

                        userDTO.Permissions = new List<string>();

                        foreach (var permission in permissions)
                        {
                            userDTO.Permissions.Add(permission);
                        }

                        return userDTO;
                    }
                    else
                    {
                        throw new InvalidCredentialException("Wrong Credentials");
                    }
                    
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    
                    throw ex;
                }
            }
        }

        public bool AssignUserRole(int userId, string roleName, bool updateExistingRole = false)
        {
            // permissions are fetched seprately per role not per user
            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                string storedProcedure = "";

                if (updateExistingRole) storedProcedure = "[Authorize].[SP_ChangeUserRole]";
                else storedProcedure = "[Authorize].[SP_GiveUserRole]";

                try
                { 
                    var cmd = new SqlCommand(storedProcedure, con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@RoleName", roleName);

                    cmd.ExecuteNonQuery();

                    return true;
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    return false;
                }
            }
        }

        public async Task<bool> GiveUserSpecialPermission(int userId, string permissionName)
        {
            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {

                    var cmd = new SqlCommand("[Authorize].[SP_GiveUserSpecialPermission]", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@PermissionName", permissionName);

                    await cmd.ExecuteNonQueryAsync();

                    return true;
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    return false;
                }
            }
        }

        public async Task<bool> RemoveUserSpecialPermission(int userId, string permissionName)
        {
            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("[Authorize].[SP_RemoveUserSpecialPermission]", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@PermissionName", permissionName);

                    await cmd.ExecuteNonQueryAsync();

                    return true;
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    return false;
                }
            }
        }

    }
}
