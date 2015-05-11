using Microsoft.Practices.ServiceLocation;
using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GitCITestRepo
{
    public class MyServiceLocator
    {
        public MyServiceLocator()
        {
            var container = new UnityContainer();
            ServiceLocator.SetLocatorProvider(() => new UnityServiceLocator(container));
            Register(container);
        }

        public static void Register(IUnityContainer container)
        {
            container.RegisterType<ICalculator, Calculator>();
    }
    }
}
