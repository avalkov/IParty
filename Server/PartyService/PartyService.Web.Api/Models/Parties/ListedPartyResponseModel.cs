namespace PartyService.Web.Api.Models.Parties
{
    using AutoMapper;

    using PartyService.Models;
    using PartyService.Web.Api.Infrastructure.Mappings;

    public class ListedPartyResponseModel: IMapFrom<Party>, IHaveCustomMappings
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public string ImageUrl { get; set; }

        public int MembersCount { get; set; }

        public double Longitude { get; set; }

        public double Latitude { get; set; }

        public double Distance { get; set; }

        public void CreateMappings(IConfiguration configuration)
        {
            configuration.CreateMap<Party, ListedPartyResponseModel>()
                .ForMember(lp => lp.ImageUrl, opts => opts.MapFrom(p => p.FrontImageData != null ? p.FrontImageData.Url : null))
                .ForMember(lp => lp.MembersCount, opts => opts.MapFrom(p => p.Members.Count));
        }
    }
}