namespace PartyService.Models
{
    using System.ComponentModel.DataAnnotations;

    public class InviteResponse
    {
        [Key]
        public int Id { get; set; }

        public string ReceiverId { get; set; }

        public virtual User Receiver { get; set; }

        public string SenderId { get; set; }

        public virtual User Sender { get; set; }

        public int PartyId { get; set; }

        public virtual Party Party { get; set; }
    }
}
