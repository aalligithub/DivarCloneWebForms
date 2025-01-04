using System;
using System.Collections.Generic;
using System.Configuration.Provider;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using DivarClone.DAL;
using System.Configuration;

namespace DivarCloneWebForms
{
    public class Global : HttpApplication
    {

        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            PermissionCacheManager.LoadRolePermissions(ConfigurationManager.ConnectionStrings["DivarCloneContextConnection"].ConnectionString);
            
        }

    }
}