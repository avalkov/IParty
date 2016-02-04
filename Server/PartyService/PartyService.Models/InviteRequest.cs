namespace PartyService.Models
{
    using System.ComponentModel.DataAnnotations;

    public class InviteRequest
    {
        [Key]
        public int Id { get; set; }

        public string SenderId { get; set; }

        public virtual User Sender { get; set; }

        public int TargetId { get; set; }

        public virtual Party Target { get; set; }
    }
}
