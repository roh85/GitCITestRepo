using Microsoft.Practices.ServiceLocation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GitCITestRepo
{
    class Program
    {
        static void Main(string[] args)
        {
            MyServiceLocator myservicelocator = new MyServiceLocator();
            MainAsync(args).Wait();
        }

        public static async Task MainAsync(string[] args)
        {
            var calculator = ServiceLocator.Current.GetInstance<ICalculator>();
            int result = calculator.Multiply(2, 3);
            Console.WriteLine(result);
            Console.ReadLine();
        }
    }
}
