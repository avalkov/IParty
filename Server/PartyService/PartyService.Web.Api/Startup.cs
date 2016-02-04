using System.Web.Http;
using Microsoft.Owin;
using Owin;

using Ninject.Web.Common.OwinHost;
using Ninject.Web.WebApi.OwinHost;

using PartyService.Web.Api.App_Start;
using PartyService.Common.Constants;

[assembly: OwinStartup(typeof(PartyService.Web.Api.Startup))]

namespace PartyService.Web.Api
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            AutoMapperConfig.RegisterMappings(Assemblies.WebApi);

            ConfigureAuth(app);

            var httpConfig = new HttpConfiguration();

            WebApiConfig.Register(httpConfig);

            httpConfig.EnsureInitialized();

            app
                .UseNinjectMiddleware(NinjectConfig.CreateKernel)
                .UseNinjectWebApi(httpConfig);
        }
    }
}
