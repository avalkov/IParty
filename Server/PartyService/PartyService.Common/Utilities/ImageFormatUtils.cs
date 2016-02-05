namespace PartyService.Common.Utilities
{
    using System;
    using System.Drawing.Imaging;
    using System.Linq;

    public static class ImageFormatUtils
    {
        public static string FileExtensionFromEncoder(ImageFormat format)
        {
            try
            {
                return ImageCodecInfo.GetImageEncoders()
                        .First(x => x.FormatID == format.Guid)
                        .FilenameExtension
                        .Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries)
                        .First()
                        .Trim('*')
                        .ToLower();
            }
            catch (Exception)
            {
                throw new InvalidOperationException();
            }
        }

        public static string FileExtensionFromToString(ImageFormat format)
        {
            return "." + format.ToString().ToLower();
        }
    }
}
