using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

        public void LogToOutput(string message) {
            System.Console.WriteLine(message);
        }

        public void LogError(string message) => LogToOutput($"ERROR: {message}");
        public void LogInfo(string message) => LogToOutput($"INFO: {message}");
    }
}
