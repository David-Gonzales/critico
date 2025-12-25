namespace Common.Interfaces
{
    public interface IDateTimeService
    {
        DateTime NowUtc { get; }
        DateTime NowPeru { get; }
    }
}
