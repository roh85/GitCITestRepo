using Microsoft.VisualStudio.TestTools.UnitTesting;
using GitCITestRepo.Program;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Moq;

namespace GitCITestRepo.Program.Tests
{
    [TestClass()]
    public class CalculatorTests
    {
        [TestMethod()]
        public void MultiplyTest()
        {
            var mock = new Mock<ICalculator>();
            mock.Setup(calculator => calculator.Multiply(2, 3)).Returns(6);
        }
    }
}