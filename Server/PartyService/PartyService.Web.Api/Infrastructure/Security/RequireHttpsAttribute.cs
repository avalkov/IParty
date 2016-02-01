namespace PartyService.Web.Api.Infrastructure.Security
{
    using System;
    using System.Net.Http;
    using System.Web.Http.Controllers;
    using System.Web.Http.Filters;

    using Common.Constants;

    public class RequireHttpsAttribute : AuthorizationFilterAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            if (actionContext.Request.RequestUri.Scheme != Uri.UriSchemeHttps)
            {
                actionContext.Response = new HttpResponseMessage(System.Net.HttpStatusCode.Forbidden)
                {
                    ReasonPhrase = GlobalConstants.HTTPSRequired
                };
            }
            else
            {
                base.OnAuthorization(actionContext);
            }
        }
    }
}