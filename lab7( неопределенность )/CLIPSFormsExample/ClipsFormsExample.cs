using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using CLIPSNET;


namespace ClipsFormsExample
{
    public partial class ClipsFormsExample : Form
    {
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();

        private List<TrackBar_W> facts = new List<TrackBar_W>();

        public ClipsFormsExample()
        {
            InitializeComponent();
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
        }

        private bool HandleResponse()
        {
            //  Вытаскиаваем факт из ЭС
            String evalStr = "(find-fact ((?f ioproxy)) TRUE)";
            FactAddressValue fv = (FactAddressValue)((MultifieldValue)clips.Eval(evalStr))[0];

            MultifieldValue damf = (MultifieldValue)fv["messages"];
            MultifieldValue vamf = (MultifieldValue)fv["answers"];

            for (int i = 0; i < damf.Count; i++)
            {
                LexemeValue da = (LexemeValue)damf[i];
                byte[] bytes = Encoding.Default.GetBytes(da.Value);
                string message = Encoding.UTF8.GetString(bytes);
                outputBox.Text += message + System.Environment.NewLine;

                //if(message == "")
                //{
                //    if (vamf.Count == 0)
                //        clips.Eval("(assert (clearmessage))");
                //    return false;
                //}

            }

            if (damf.Count == 0)
            {
                if (vamf.Count == 0)
                {
                    clips.Eval("(assert (clearmessage))");
                }

                return false;
            }

            if (vamf.Count == 0)
            {
                clips.Eval("(assert (clearmessage))");
            }

            return true;
        }

        private void nextBtn_Click(object sender, EventArgs e)
        {
            Add_Fact();
        }

        private void openFile_Click(object sender, EventArgs e)
        {
            Loadd();
        }

        public void Loadd()
        {
            if (clipsOpenFileDialog.ShowDialog() == DialogResult.OK)
            {
                codeBox.Text = System.IO.File.ReadAllText(clipsOpenFileDialog.FileName);
                Text = "Табачка – " + clipsOpenFileDialog.FileName;
            }
        }

        public void Load_Idle()
        {
            codeBox.Text = System.IO.File.ReadAllText("C:\\Users\\Владимир Садовский\\Desktop\\CLIPSFormsExample\\tabacco.clp");
            Text = "Табачка – " + "C:\\Users\\Владимир Садовский\\Desktop\\CLIPSFormsExample\\tabacco.clp";
        }

        private void saveAsButton_Click(object sender, EventArgs e)
        {
            clipsSaveFileDialog.FileName = clipsOpenFileDialog.FileName;
            if (clipsSaveFileDialog.ShowDialog() == DialogResult.OK)
            {
                System.IO.File.WriteAllText(clipsSaveFileDialog.FileName, codeBox.Text);
            }
        }

        private void splitContainer1_Panel2_Paint(object sender, PaintEventArgs e)
        {

        }

        private void ClipsFormsExample_Load(object sender, EventArgs e)
        {

            //Load_Idle();

            List<string> fact_name = new List<string>() 
            {
                "Легкая крепость", "Средняя крепость", "Тяжелая крепость", 
                "Очень тяжелая крепость", "Низкая стоимость", "Средняя стоимость", "Высокая стоимость", 
                "Чайный лист", "Табачный лист Вирджиния", "Табачный лист Ориентал", "Табачный лист Бёрли", 
                "Паста для кальяна", "Производство Россия", "Производство Америка", "Производство ОАЭ" 
            };

            ScrollBox.Controls.Clear();

            //double d = 1.15;

            for (int i = 1; i <= 15; i++)
            {
                TrackBar_W fact = new TrackBar_W();
                
                fact.name = "f" + i.ToString();

                fact.Set_Text(fact_name[i-1]);

                //fact.Set_Text(d.ToString().Replace(',','.'));

                facts.Add(fact);

                ScrollBox.Controls.Add(fact);
            }

            ScrollBox.Refresh();
        }

        private void Add_Fact()
        {
            clips.Clear();
            clips.LoadFromString(codeBox.Text);
            clips.Reset();

            clips.Run();
            HandleResponse();

            foreach (var f in facts)
            {
                if(f.Get_Value() != 0)
                {
                    var ff = f.Get_Value();
                    clips.Eval($"(assert (base (name {f.name}) (weight {f.Get_Value().ToString().Replace(',','.')})))");

                    //clips.Run();
                    //HandleResponse();

                    //clips.Run();
                    //HandleResponse();
                }
            }

            bool b = true;
            while (b)
            {
                clips.Run();
                b = HandleResponse();
            }
        }
    }
}
