using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProductionSystem
{
    class Rule
    {
        private string id;

        private List<string> conditions = new List<string>();

        private string conclusion;

        private double weight;

        public string Id { get { return id; } }

        public List<string> Conditions { get { return conditions; } }

        public string Conclusion { get { return conclusion; } }

        public double Weight { get { return weight; } set { weight = value; } }

        public Rule (string i, List<string> cond, string concl)
        {
            id = i;
            conditions = cond;
            conclusion = concl;
            weight = 0;
        }
    }
}
