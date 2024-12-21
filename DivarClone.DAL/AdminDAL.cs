using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Shared;

namespace DivarClone.DAL
{
    public interface IAdminDAL
    {
        List<UserDTO> GetAllUsers(string username = null, string email = null, string permissionName = null, string roleName = null);
    }
    public class AdminDAL : IAdminDAL
    {
        public string Constr { get; set; }
        public SqlConnection con;
        private readonly string _connectionString;

        public AdminDAL(string connectionString)
        {
            con = new SqlConnection(Constr);
            _connectionString = connectionString;
            Constr = _connectionString;
        }

        public List<UserDTO> GetAllUsers(string username = null, string email = null, string permissionName = null, string roleName = null)
        {
            var users = new List<UserDTO>();

            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("[Enrollement].[SP_GetAllUsers]", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    if (!string.IsNullOrEmpty(username)) cmd.Parameters.AddWithValue("@Username", username);
                    if (!string.IsNullOrEmpty(email)) cmd.Parameters.AddWithValue("@Email", email);
                    if (!string.IsNullOrEmpty(permissionName)) cmd.Parameters.AddWithValue("@PermissionName", permissionName);
                    if (!string.IsNullOrEmpty(roleName)) cmd.Parameters.AddWithValue("@RoleName", roleName);

                    SqlDataReader rdr = cmd.ExecuteReader();

                    while (rdr.Read())
                    {
                        var userDTO = new UserDTO()
                        {
                            Id = Convert.ToInt32(rdr["Id"]),
                            Name = rdr["FirstName"].ToString(),
                            Username = rdr["Username"].ToString(),
                            Email = rdr["Email"].ToString(),
                            PhoneNumber = rdr["Phone"].ToString(),
                            Role = rdr["RoleName"].ToString()
                        };

                        var permissions = rdr["Permissions"].ToString().Split(',');

                        var userPermissions = new List<string>();

                        foreach (var permission in permissions)
                        {
                            userPermissions.Add(permission);
                        }
                        userDTO.Permissions = userPermissions;

                        users.Add(userDTO);
                    }

                    return users;
                }
                catch (Exception ex)
                {
                    Logger.Instance.LogError($"Connection to Database failed : {ex}");
                    throw;
                }
            }
        }
    }
}
