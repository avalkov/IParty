namespace PartyService.Models
{
    using System.Security.Claims;
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using Microsoft.AspNet.Identity;
    using Microsoft.AspNet.Identity.EntityFramework;
    
    public class User : IdentityUser
    {
        private ICollection<Party> parties;
        private ICollection<InviteResponse> invitesResponses;

        public User()
        {
            this.parties = new HashSet<Party>();
            this.invitesResponses = new HashSet<InviteResponse>();
        }

        public virtual ICollection<Party> Parties
        {
            get { return this.parties; }
            set { this.parties = value; }
        }

        /*
        public virtual ICollection<InviteResponse> InvitesResponses
        {
            get { return this.invitesResponses; }
            set { this.invitesResponses = value; }
        } */

        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<User> manager, string authenticationType)
        {
            var userIdentity = await manager.CreateIdentityAsync(this, authenticationType);
 
            return userIdentity;
        }
    }
}
