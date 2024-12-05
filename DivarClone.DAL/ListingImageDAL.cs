using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Shared;
using static DivarClone.DAL.ListingDTO;

namespace DivarClone.DAL
{
    public interface IListingImageDAL
    {
        Task<bool> InsertImagePathIntoDB(int? ListingId, List<string> PathToImageFTP, string imageHash);
    }
    public class ListingImageDAL : IListingImageDAL
    {
        public string Constr { get; set; }
        public SqlConnection con;
        private readonly string _connectionString;

        public ListingImageDAL(string connectionString)
        {
            con = new SqlConnection(Constr);
            _connectionString = connectionString;
            Constr = _connectionString;
        }

        public async Task<bool> InsertImagePathIntoDB(int? listingId, List<string> PathToImageFTP, string fileHash)
        {
            try
            {
                if (con != null && con.State == ConnectionState.Closed)
                {
                    con.Open();
                }

                using (var cmd = new SqlCommand("SP_InsertImagePathIntoImages", con))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    foreach (var path in PathToImageFTP)
                    {
                        cmd.Parameters.AddWithValue("@ListingId", listingId);
                        cmd.Parameters.AddWithValue("@ImagePath", path);

                        cmd.Parameters.AddWithValue("@ImageHash", fileHash);

                        await cmd.ExecuteNonQueryAsync();
                        cmd.Parameters.Clear();
                    }
                    return true;
                }
            }
            catch (SqlException ex)
            {
                Logger.Instance.LogError(ex+ "Sql connection failed to insert image into DB");
                return false;
            }

            catch (Exception ex)
            {
                Logger.Instance.LogError(ex + "Unknown Error");
                return false;
            }

            finally
            {
                Logger.Instance.LogInfo("\n Successfully added image path to db");
            }
        }
    }
}
