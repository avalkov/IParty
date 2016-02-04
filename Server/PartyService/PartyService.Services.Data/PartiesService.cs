﻿namespace PartyService.Services.Data
{
    using System;
    using System.Linq;
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

        public Party CreateParty(string userId, string title, string description, DateTime startTime, DateTime creationTime)
        {
            var party = new Party()
            {
                UserId = userId,
                Title = title,
                Desription = description,
                StartTime = startTime,
                CreationTime = creationTime
            };

            var user = this.users
                .GetById(userId);

            this.parties.Add(party);
            this.parties.SaveChanges();

            return party;
        }

        public IQueryable<Party> GetPartyDetails(int partyId)
        {
            return this.parties
                .All()
                .Where(p => p.Id == partyId);
        }
    }
}