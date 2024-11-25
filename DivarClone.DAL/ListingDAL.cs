using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using static DivarClone.DAL.ListingDTO;

namespace DivarClone.DAL
{
    public interface IListingDAL
    {
        List<ListingDTO> GetAllListings();
    }

    public class ListingDTO
    {
        public enum Category //enum تعریف کردیم که کتگوری فقط از اعضای از پیش تایین شده انتخاب شود
        {
            Electronics,
            Realstate,
            Vehicles
        }

        public int Id { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public int? Price { get; set; }

        public string Poster { get; set; }

        public Category category { get; set; }

        public DateTime DateTimeOfPosting { get; set; }

        public List<string> ImagePath { get; set; } = new List<string>();

        public List<string> ImageData { get; set; } = new List<string>();
    }

    public class ListingDAL : IListingDAL
    {
        public string Constr { get; set; }
        public SqlConnection con;
        private readonly string _connectionString;

        public ListingDAL(string connectionString)
        {
            con = new SqlConnection(Constr);
            _connectionString = connectionString;
            Constr = _connectionString;

        }

        public List<ListingDTO> GetAllListings()
        {
            var listingsList = new List<ListingDTO>();

            using (var con = new SqlConnection(Constr))
            {
                con.Open();

                try
                {
                    var cmd = new SqlCommand("SP_GetListingsWithImages", con);

                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    SqlDataReader rdr = cmd.ExecuteReader();

                    while (rdr.Read())
                    {
                        var listing = new ListingDTO
                        {
                            Id = Convert.ToInt32(rdr["Id"]),
                            Name = rdr["Name"].ToString(),
                            Description = rdr["Description"].ToString(),
                            Price = Convert.ToInt32(rdr["Price"]),
                            Poster = rdr["Poster"].ToString(),
                            category = (Category)Enum.Parse(typeof(Category), rdr["Category"].ToString()),
                            DateTimeOfPosting = Convert.ToDateTime(rdr["DateTimeOfPosting"]),
                            ImagePath = new List<string>()
                        };

                        listingsList.Add(listing);
                    }
                }
                catch (Exception ex)
                {
                    throw;
                }
                finally
                {
                    con.Close();
                }

                return listingsList;
            }
        }
    }
}
