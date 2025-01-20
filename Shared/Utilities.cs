using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Security;
using Newtonsoft.Json;

namespace Shared
{
    public class Logger
    {
        private static Logger _instance;
        private static readonly object _lock = new object();

        private Logger() { }

        public static Logger Instance
        {
            get
            {
                if (_instance == null)
                {
                    lock (_lock)
                    {
                        if (_instance == null)
                        {
                            _instance = new Logger();
                        }
                    }
                }
                return _instance;
            }
        }

        private static readonly string LogFilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Logs/log.txt");

        public void LogIntoFile(string message)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(LogFilePath));
            File.AppendAllText(LogFilePath, $"{DateTime.Now}: {message}{Environment.NewLine}");
        }

        public void LogToOutput(string message)
        {
            System.Console.WriteLine(message);
        }

        public void LogError(string message) => LogToOutput($"ERROR: {message}");
        public void LogInfo(string message) => LogToOutput($"INFO: {message}");
    }

    public static class PermissionHelper
    {
        public static bool HasPermission(string requiredPermission)
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                HttpCookie authCookie = HttpContext.Current.Request.Cookies[FormsAuthentication.FormsCookieName];
                if (authCookie != null)
                {
                    FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(authCookie.Value);
                    if (ticket != null)
                    {
                        var claims = JsonConvert.DeserializeObject<Dictionary<string, string>>(ticket.UserData);
                        if (claims.ContainsKey("Permissions"))
                        {
                            var permissions = claims["Permissions"].Split(',');
                            return permissions.Contains(requiredPermission);
                        }
                    }
                }
            }
            return false;
        }
    }
}
