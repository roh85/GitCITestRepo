using Microsoft.Practices.ServiceLocation;
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
            ContainerBootstrapper.Initialise();
            var calculator = ServiceLocator.Current.GetInstance<ICalculator>();
            int result = calculator.Multiply(x, y);
            return result;
        }
    }
}