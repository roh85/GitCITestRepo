using Moq;
using NUnit.Framework;

namespace GitCITestRepo.Program.Tests
{
    [TestFixture]
    public class CalculatorTests
    {
        [TestCase(2, 3, Result = 6)]
        public int MultiplyTestSucces(int x, int y)
        {          
            ICalculator c = new Calculator();
            return c.Multiply(x, y);
        }
    }
}