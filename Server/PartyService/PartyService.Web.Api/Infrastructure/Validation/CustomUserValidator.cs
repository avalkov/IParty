using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

using Microsoft.AspNet.Identity;

using PartyService.Models;

namespace PartyService.Web.Api.Infrastructure.Validation
{
    public class CustomUserValidator<T> : UserManager<User>
    {
        public CustomUserValidator(IUserStore<User> store) 
            : base(store)
        {

        }

        public override Task<IdentityResult> ConfirmEmailAsync(string userId, string token)
        {
            var result = new Task<IdentityResult>( () => { return new IdentityResult(""); } );

            return result;
        }
    }
}