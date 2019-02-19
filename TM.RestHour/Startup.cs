using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(TM.RestHour.Startup))]
namespace TM.RestHour
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
