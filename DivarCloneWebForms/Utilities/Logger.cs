using System;
using System.IO;

namespace DivarCloneWebForms.Utilities
{
    public static class Logger
    {
        private static readonly string LogFilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Logs/log.txt");

        public static void Log(string message)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(LogFilePath));
            File.AppendAllText(LogFilePath, $"{DateTime.Now}: {message}{Environment.NewLine}");
        }

        public static void LogError(string message) => Log($"ERROR: {message}");
        public static void LogInfo(string message) => Log($"INFO: {message}");
    }
}