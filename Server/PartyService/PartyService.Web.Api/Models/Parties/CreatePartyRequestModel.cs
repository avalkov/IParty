namespace PartyService.Web.Api.Models.Parties
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class CreatePartyRequestModel
    {
        [Required]
        public string Title { get; set; }

        [Required]
        public string Description { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        [Required]
        public double Longitude { get; set; }

        [Required]
        public double Latitude { get; set; }

        [Required]
        public string LocationAddress { get; set; }
    }
}