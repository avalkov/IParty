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
    using Common.Utilities;
    using System.Threading;
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

        [Route("api/party/search")]
        [HttpPost]
        [ValidateModel]
        public IHttpActionResult GetNearbyParties(FindPartyRequestModel findPartyRequestModel)
        {
            var partyResult = this.partyService
                .GetNearbyParties(findPartyRequestModel.Latitude, findPartyRequestModel.Longitude)
                .ProjectTo<ListedPartyResponseModel>()
                .ToList();

            var geotool = new GeoCoordinateTool();
            GeoCoordinate userCoordinates = new GeoCoordinate(findPartyRequestModel.Latitude, findPartyRequestModel.Longitude);

            for (int i = 0; i < partyResult.Count; i++)
            {
                GeoCoordinate partyCoordinates = new GeoCoordinate(partyResult[i].Latitude, partyResult[i].Longitude);
                partyResult[i].Distance = Math.Round(geotool.Distance(userCoordinates, partyCoordinates), 2);
            }

            Thread.Sleep(5000);

            return this.Ok<List<ListedPartyResponseModel>>(partyResult);
        }
    }
}
