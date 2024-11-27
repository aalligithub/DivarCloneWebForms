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
        private static readonly Logger _instance = new Logger();

        private Logger() { }

        public static Logger Instance => _instance;

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
