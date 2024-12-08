using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Shared;
using static DivarClone.DAL.UserDTO;
using static DivarClone.DAL.ListingDTO;

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
    }

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

                        // Use the correct alias name "Permissions" from your SQL query
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
            // for debugging
            // foreach (var roleName in RolePermissionsCache.Keys)
            // {
            //     var permissions = string.Join(", ", RolePermissionsCache[roleName]); // Combine the permissions into a single string
            //     System.Diagnostics.Debug.WriteLine($"Role: {roleName}, Permissions: {permissions}");
            // }
        }
    }

    public interface IAuthenticationDAL
    {
        Task<bool> SignUserIn(UserDTO userDTO);

        //Task<bool> LogUserIn(UserDTO userDTO);

        Task<bool> GiveUserRole(int userId);

        Task<bool> GiveUserSpecialPermission(int userId);
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

        public async Task<bool> SignUserIn(UserDTO userDTO)
        {
            var userId = 0;

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

                    SqlDataReader rdr = await cmd.ExecuteReaderAsync();

                    //at this point Im sleepy so

                    if (rdr.Read()) {
                        userId = Convert.ToInt32(rdr["Id"]); 
                    }
                    else
                    {
                        return false;
                    }

                    GiveUserRole(userId, baseRoll:true);

                    return true;
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");

                    return false;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        public async Task<bool> EvaluateUser(string email, string password)
        {
            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("[Enrollement].[SP_LogUserIn]", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    SqlDataReader rdr = cmd.ExecuteReader();

                    if (rdr.Read())
                    {
                        var userDTO = new UserDTO()
                        {
                            Id = Convert.ToInt32(rdr["Id"]),
                            Name = rdr["Name"].ToString(),
                            Username = rdr["Username"].ToString(),
                            Email = rdr["Email"].ToString(),
                            PhoneNumber = rdr["Phone"].ToString(),
                            Role = rdr["RoleName"].ToString(),
                        };
                    }

                    //await AuthenticateUser(userDTO);

                    return true;
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    
                    return false;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        public async Task<bool> AuthenticateUser(UserDTO user)
        {
            //set session cookies and policies
            //use UserDTO.role and map permissions to the users policies
            return true;
        }

        public async Task<bool> GiveUserRole(int userId, bool baseRoll = false)
        {
            // should be dynamic to handle role changes and default roles probably with parameters used with SignUserIn
            // permissions are fetched seprately per role not per user
            if (baseRoll != false)
            {
                //give user base role
                return true;
            }

            return true;
        }

        public async Task<bool> GiveUserSpecialPermission(int userId)
        {
            return true;
        }
    }
}
