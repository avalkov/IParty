namespace PartyService.Services.Data
{
    using System;
    using System.Linq;
    using System.Data.Entity.SqlServer;

    using Contracts;
    using Models;
    using PartyService.Data.Repositories;

    public class PartiesService : IPartiesService
    {
        private IGenericRepository<Party> parties;
        private IGenericRepository<User> users;

        public PartiesService(IGenericRepository<Party> parties, IGenericRepository<User> users)
        {
            this.parties = parties;
            this.users = users;
        }

        public bool AddImageToParty(int id, string userId, string imageUrl)
        {
            var party = this.parties.All()
                .Where(a => a.Id == id && a.UserId == userId)
                .FirstOrDefault();

            if (party == null)
            {
                return false;
            }

            var imageData = new ImageData()
            {
                Url = imageUrl
            };

            if (party.FrontImageData == null)
            {
                party.FrontImageData = imageData;
            }

            party.ImagesData.Add(imageData);
            this.parties.SaveChanges();

            return true;
        }

        public Party CreateParty(string userId, string title, string description, double longitude, double latidude, 
            string locationAddress, DateTime startTime, DateTime creationTime)
        {
            var party = new Party()
            {
                UserId = userId,
                Title = title,
                Description = description,
                Longitude = longitude,
                Latitude = latidude,
                LocationAddress = locationAddress,
                StartTime = startTime,
                CreationTime = creationTime
            };

            var user = this.users
                .All()
                .Where(u => u.Id == userId)
                .FirstOrDefault();

            this.parties.Add(party);
            party.Members.Add(user);

            user.Parties.Add(party);
            this.users.SaveChanges();

            return party;
        }

        public IQueryable<Party> GetPartyDetails(int partyId)
        {
            return this.parties
                .All()
                .Where(p => p.Id == partyId);
        }

        public IQueryable<Party> GetUserParties(string userId)
        {
            return this.users
                .All()
                .Where(u => u.Id == userId)
                .SelectMany(u => u.Parties);
        }

        public IQueryable<Party> GetNearbyParties(double latitude, double longitude)
        {
            // Haversine formula : https://en.wikipedia.org/wiki/Haversine_formula

            var result = this.parties.All().Select(x => 12742 * SqlFunctions.Asin(SqlFunctions.SquareRoot(SqlFunctions.Sin(((SqlFunctions.Pi() / 180) * (x.Latitude - latitude)) / 2) * SqlFunctions.Sin(((SqlFunctions.Pi() / 180) * (x.Latitude - latitude)) / 2) +
                                                SqlFunctions.Cos((SqlFunctions.Pi() / 180) * latitude) * SqlFunctions.Cos((SqlFunctions.Pi() / 180) * (x.Latitude)) *
                                                SqlFunctions.Sin(((SqlFunctions.Pi() / 180) * (x.Longitude - longitude)) / 2) * SqlFunctions.Sin(((SqlFunctions.Pi() / 180) * (x.Longitude - longitude)) / 2)))).ToList();

            return this.parties.All().OrderBy(x => 12742 * SqlFunctions.Asin(SqlFunctions.SquareRoot(SqlFunctions.Sin(((SqlFunctions.Pi() / 180) * (x.Latitude - latitude)) / 2) * SqlFunctions.Sin(((SqlFunctions.Pi() / 180) * (x.Latitude - latitude)) / 2) +
                                                SqlFunctions.Cos((SqlFunctions.Pi() / 180) * latitude) * SqlFunctions.Cos((SqlFunctions.Pi() / 180) * (x.Latitude)) *
                                                SqlFunctions.Sin(((SqlFunctions.Pi() / 180) * (x.Longitude - longitude)) / 2) * SqlFunctions.Sin(((SqlFunctions.Pi() / 180) * (x.Longitude - longitude)) / 2))));
        }
    }
}
