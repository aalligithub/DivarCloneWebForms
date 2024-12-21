using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DivarClone.DAL;
using Shared;

namespace DivarClone.BLL
{
    public interface IAdminBLL
    {
        List<UserDTO> GetAllUsers(
            string username = null,
            string email = null,
            string permissionName = null,
            string roleName = null);
    }
    public class AdminBLL : IAdminBLL
    {
        private readonly IAdminDAL _adminDAL;

        public AdminBLL(IAdminDAL adminDAL)
        {
            _adminDAL = adminDAL;
        }

        public List<UserDTO> GetAllUsers(
            string username = null,
            string email = null,
            string permissionName = null,
            string roleName = null)
        {
            try
            {
                var users = new List<UserDTO>(_adminDAL.GetAllUsers());

                return users;
            }
            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Error when accessing AdminDAL method");
                return null;
            }       
        }
    }
}
