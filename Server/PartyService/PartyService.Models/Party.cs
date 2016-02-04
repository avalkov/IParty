﻿namespace PartyService.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public class Party
    {
        private ICollection<User> members;
        private ICollection<ImageData> images;
        private ICollection<InviteRequest> invitesRequests;

        public Party()
        {
            this.members = new HashSet<User>();
            this.images = new HashSet<ImageData>();
            this.invitesRequests = new HashSet<InviteRequest>();
        }

        [Key]
        public int Id { get; set; }

        public bool IsDeleted { get; set; }

        [Required]
        [MinLength(5), MaxLength(50)]
        public string Title { get; set; }

        [Required]
        [MinLength(20), MaxLength(500)]
        public string Desription { get; set; }

        [Required]
        public DateTime CreationTime { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        public string UserId { get; set; }

        public virtual User User { get; set; }

        public virtual ICollection<User> Members
        {
            get { return this.members; }
            set { this.members = value; }
        }
        
        public virtual ICollection<ImageData> Images
        {
            get { return this.images; }
            set { this.images = value; }
        }

        public virtual ICollection<InviteRequest> InvitesRequests
        {
            get { return this.invitesRequests; }
            set { this.invitesRequests = value; }
        }
    }
}