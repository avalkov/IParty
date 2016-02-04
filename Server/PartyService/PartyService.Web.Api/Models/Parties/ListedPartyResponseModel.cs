namespace PartyService.Web.Api.Models.Parties
{
    using PartyService.Models;
    using PartyService.Web.Api.Infrastructure.Mappings;

    public class ListedPartyResponseModel: IMapFrom<Party>
    {
        public int Id { get; set; }
    }
}