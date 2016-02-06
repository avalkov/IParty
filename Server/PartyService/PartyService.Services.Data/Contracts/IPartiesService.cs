namespace PartyService.Services.Data.Contracts
{
    using System;
    using System.Linq;

    using Models;
    
    public interface IPartiesService
    {
        Party CreateParty(string userId, string title, string description, float longitude, float latidude, string locationAddress,
            DateTime startTime, DateTime creationTime);

        IQueryable<Party> GetPartyDetails(int partyId);

        IQueryable<Party> GetUserParties(string userId);

        bool AddImageToParty(int id, string userId, string imageUrl);
    }
}
