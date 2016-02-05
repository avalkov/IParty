namespace PartyService.Services.Data
{
    using System;
    using System.Net.Http;
    using System.IO;
    using System.Drawing;
    using System.Threading.Tasks;

    using Contracts;
    using PartyService.Common.Utilities;

    public class ImagesService : IImagesService
    {
        private readonly Random random = new Random(DateTime.Now.Millisecond);

        public async Task<string> StoreImage(HttpContent content, string path, int advertId, string userId)
        {
            Stream stream = await content.ReadAsStreamAsync();
            string fileName = null;

            try
            {
                Image image = Image.FromStream(stream);
                var extension = ImageFormatUtils.FileExtensionFromEncoder(image.RawFormat);
                fileName = string.Format("{0}{1}{2}{3}{4}", advertId, userId, DateTime.Now.Ticks, random.Next() % 10000007, extension);
                var fullPath = Path.Combine(path, fileName);
                image.Save(fullPath);
            }
            catch
            {
                throw new InvalidDataException();
            }

            return fileName;
        }
    }
}
