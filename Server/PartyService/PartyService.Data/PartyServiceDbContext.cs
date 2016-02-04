namespace PartyService.Data
{
    using System;
    using System.Data.Entity;

    using Microsoft.AspNet.Identity.EntityFramework;

    using PartyService.Models;

    public class PartyServiceDbContext : IdentityDbContext<User>, IPartyServiceDbContext
    {
        public PartyServiceDbContext()
            : base("DefaultConnection", throwIfV1Schema: false)
        {

        }

        public IDbSet<Party> Parties { get; set; }

       // public IDbSet<InviteRequest> invitesRequests { get; set; }

      //  public IDbSet<InviteResponse> invitesResponses { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<User>()
                .HasMany<Party>(u => u.Parties)
                .WithMany(p => p.Members)
                .Map(cs =>
                {
                    cs.MapLeftKey("UserId");
                    cs.MapRightKey("PartyId");
                    cs.ToTable("UsersParties");
                });

            /*
            modelBuilder.Entity<User>()
                .HasMany<Issue>(u => u.ReportedAsIncorrectIssues)
                .WithMany(a => a.ReportedAsIncorrectUsers)
                .Map(cs =>
                {
                    cs.MapLeftKey("UserId");
                    cs.MapRightKey("IssueId");
                    cs.ToTable("ReportedAsIncorrectUsersIssues");
                });*/
        }
        

        public static PartyServiceDbContext Create()
        {
            return new PartyServiceDbContext();
        }
    }
}
