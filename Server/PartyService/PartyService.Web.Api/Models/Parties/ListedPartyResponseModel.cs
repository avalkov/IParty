namespace PartyService.Web.Api.Models.Parties
{
    using PartyService.Models;
    using PartyService.Web.Api.Infrastructure.Mappings;

    public class ListedPartyResponseModel: IMapFrom<Party>
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }
    }
}