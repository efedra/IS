using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProductionSystem
{
    class Fact
    {
        
        private string id;
        private string value;
        private double weight;

        public string Id { get { return id; } }

        public string Value { get { return value; } }

        public double Weight { get { return weight; } set { weight = value; } }

        public Fact(string i, string val, double w)
        {
            id = i;
            value = val;
            weight = w;
        }
    }
}
