using Common.Interfaces;

namespace Services.Common

{
    public class DateTimeService : IDateTimeService
    {
        public DateTime NowUtc => DateTime.UtcNow;

        public DateTime NowPeru => TimeZoneInfo.ConvertTimeFromUtc(
            DateTime.UtcNow, 
            TimeZoneInfo.FindSystemTimeZoneById("SA Pacific Standard Time")
            );
    }
}
