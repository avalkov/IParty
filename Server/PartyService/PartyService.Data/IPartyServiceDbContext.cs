﻿namespace PartyService.Data
{
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;

    using Models;

    public interface IPartyServiceDbContext
    {
    //    IDbSet<User> Users { get; set; }

   //     IDbSet<Party> Parties { get; set; }

     //   IDbSet<InviteRequest> invitesRequests { get; set; }

     //   IDbSet<InviteResponse> invitesResponses { get; set; }

        DbSet<TEntity> Set<TEntity>() where TEntity : class;

        DbEntityEntry<TEntity> Entry<TEntity>(TEntity entity) where TEntity : class;

        int SaveChanges();

        void Dispose();

    }
}
