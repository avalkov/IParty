namespace PartyService.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public class Party
    {
        private ICollection<User> members;
        private ICollection<ImageData> imagesData;
        private ICollection<InviteRequest> invitesRequests;

        public Party()
        {
            this.members = new HashSet<User>();
            this.imagesData = new HashSet<ImageData>();
            this.invitesRequests = new HashSet<InviteRequest>();
        }

        [Key]
        public int Id { get; set; }

        public bool IsDeleted { get; set; }

        public ImageData FrontImageData { get; set; }

        [Required]
        [MinLength(5), MaxLength(50)]
        public string Title { get; set; }

        [Required]
        [MinLength(20), MaxLength(500)]
        public string Description { get; set; }

        [Required]
        public DateTime CreationTime { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        [Required]
        public double Longitude { get; set; }

        [Required]
        public double Latitude { get; set; }

        [Required]
        public string LocationAddress { get; set; }

        public string UserId { get; set; }

        public virtual User User { get; set; }

        public virtual ICollection<User> Members
        {
            get { return this.members; }
            set { this.members = value; }
        }
        
        public virtual ICollection<ImageData> ImagesData
        {
            get { return this.imagesData; }
            set { this.imagesData = value; }
        }

        public virtual ICollection<InviteRequest> InvitesRequests
        {
            get { return this.invitesRequests; }
            set { this.invitesRequests = value; }
        }
    }
}
