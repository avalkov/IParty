namespace PartyService.Services.Data.Contracts
{
    using System;
    using System.Linq;

    using Models;
    
    public interface IPartiesService
    {
        Party CreateParty(string userId, string title, string description, DateTime startTime, DateTime creationTime);

        IQueryable<Party> GetPartyDetails(int partyId);
    }
}
