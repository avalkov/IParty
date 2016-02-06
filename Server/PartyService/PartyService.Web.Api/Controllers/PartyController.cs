namespace PartyService.Web.Api.Controllers
{
    using System;
    using System.Linq;
    using System.Web.Http;
    using System.Collections.Generic;
    using Microsoft.AspNet.Identity;

    using AutoMapper.QueryableExtensions;

    using Services.Data.Contracts;
    using Infrastructure.Validation;
    using Models.Parties;
    
    [Authorize]
    public class PartyController : ApiController
    {
        private IPartiesService partyService;

        public PartyController(IPartiesService partyService)
        {
            this.partyService = partyService;
        }

        [ValidateModel]
        public IHttpActionResult Post(CreatePartyRequestModel createPartyRequestModel)
        {
            var userId = this.User.Identity.GetUserId();

            DateTime creationTime = DateTime.Now;
            
            var newParty = this.partyService
                .CreateParty(userId, createPartyRequestModel.Title, createPartyRequestModel.Description, 
                createPartyRequestModel.Longitude, createPartyRequestModel.Latitude, createPartyRequestModel.LocationAddress,
                createPartyRequestModel.StartTime, creationTime);

            var partyResult = this.partyService
                .GetPartyDetails(newParty.Id)
                .ProjectTo<ListedPartyResponseModel>()
                .FirstOrDefault();

            return this.Created<ListedPartyResponseModel>("", partyResult);
        }

        public IHttpActionResult GetCurrentUserParties()
        {
            var userId = this.User.Identity.GetUserId();

            var partyResult = this.partyService
                .GetUserParties(userId)
                .ProjectTo<ListedPartyResponseModel>()
                .ToList();

            return this.Ok<List<ListedPartyResponseModel>>(partyResult);
        }
    }
}
