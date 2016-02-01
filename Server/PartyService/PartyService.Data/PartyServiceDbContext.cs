namespace PartyService.Data
{
    using System.Data.Entity;

    using Microsoft.AspNet.Identity.EntityFramework;

    using PartyService.Models;

    public class PartyServiceDbContext : IdentityDbContext<User>, IPartyServiceDbContext
    {
        public PartyServiceDbContext()
            : base("DefaultConnection", throwIfV1Schema: false)
        {

        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
        }

        public static PartyServiceDbContext Create()
        {
            return new PartyServiceDbContext();
        }
    }
}
