namespace PartyService.Services.Data.Contracts
{
    using System;
    using System.Linq;

    using Models;
    
    public interface IPartiesService
    {
        Party CreateParty(string userId, string title, string description, double longitude, double latidude, string locationAddress,
            DateTime startTime, DateTime creationTime);

        IQueryable<Party> GetPartyDetails(int partyId);

        IQueryable<Party> GetUserParties(string userId);

        IQueryable<Party> GetNearbyParties(double latitude, double longitude);

        bool AddImageToParty(int id, string userId, string imageUrl);
    }
}
