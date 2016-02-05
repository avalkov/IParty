namespace PartyService.Services.Data.Contracts
{
    using System.Net.Http;
    using System.Threading.Tasks;

    public interface IImagesService
    {
        Task<string> StoreImage(HttpContent content, string path, int advertId, string userId);
    }
}
