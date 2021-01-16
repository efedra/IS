using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProductionSystem
{
    class Terminal
    {
        private string id;
        private string value;
        private string img;

        public string Id { get { return id; } }

        public string Value { get { return value; } }

        public string Img { get { return img; } }

        public Terminal(string i, string val, string image)
        {
            id = i;
            value = val;
            img = image;
        }
    }
}
