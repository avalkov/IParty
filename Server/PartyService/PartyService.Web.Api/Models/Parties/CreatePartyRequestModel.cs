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
    }
}