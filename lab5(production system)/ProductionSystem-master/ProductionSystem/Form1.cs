using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ProductionSystem
{
    public partial class Form1 : Form
    {
        //All existing facts
        private Dictionary<string, Fact> all_facts = new Dictionary<string, Fact>();

        //Facts that have been selected by the user
        private Dictionary<string, Fact> choosen_facts = new Dictionary<string, Fact>();

        //All existing notices
        private Dictionary<string, Fact> all_notices = new Dictionary<string, Fact>();

        //All existing rules
        private List<Rule> rules = new List<Rule>();

        //All existing terminal facts
        private Dictionary<string,Terminal> all_terminals = new Dictionary<string, Terminal>();

        //Terminal fact that have been selected by the user
        private string choosen_terminal; 

        public Form1()
        {
            InitializeComponent();
            RunForward.Hide();
            RunBackward.Hide();
        }

        private void get_facts(string filename)
        {
            List<string> lines = System.IO.File.ReadLines(filename, Encoding.GetEncoding(1251)).ToList();

            int cur_ind = 0;
            while(cur_ind < lines.Count && lines[cur_ind] != "" && lines[cur_ind][0] == 'f')
            {
                string cur = lines[cur_ind];
                int sep = cur.IndexOf(':');
                Fact f = new Fact( cur.Substring(0, sep - 1), cur.Substring(sep + 2), 0);
                all_facts[f.Id] = f;
                cur_ind++;
            }

            cur_ind++;
            while (cur_ind < lines.Count && lines[cur_ind] != "" && lines[cur_ind][0] == 'n')
            {
                string cur = lines[cur_ind];
                int sep1 = cur.IndexOf(':');
                int sep2 = cur.IndexOf(';');
                Fact f = new Fact(cur.Substring(0, sep1 - 1), cur.Substring(sep1 + 2, sep2 - sep1 - 3), double.Parse(cur.Substring(sep2 + 2)));
                all_notices[f.Id] = f;
                cur_ind++;
            }

            cur_ind++;
            while (cur_ind < lines.Count && lines[cur_ind] != "" && lines[cur_ind][0] == 't')
            {
                string cur = lines[cur_ind];
                int sep1 = cur.IndexOf(':');
                int sep2 = cur.IndexOf(';');
                Terminal t = new Terminal(cur.Substring(0, sep1 - 1), cur.Substring(sep1 + 2, sep2 - sep1 - 3), cur.Substring(sep2 + 2));
                all_terminals[t.Id] = t;
                cur_ind++;
            }

            cur_ind++;
            while (cur_ind < lines.Count && lines[cur_ind] != "" && lines[cur_ind][0] == 'r')
            {
                string cur = lines[cur_ind];
                int sep1 = cur.IndexOf(':');
                int sep2 = cur.IndexOf('-');

                string id = cur.Substring(0, sep1 - 1);
                string conditions = cur.Substring(sep1 + 2, sep2 - sep1 - 3);
                string conclusion = cur.Substring(sep2 + 3);
                List<string> cond = conditions.Split(new char[] { ',', ' ' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                Rule r = new Rule(id,cond,conclusion);
                rules.Add(r);
                cur_ind++;
            }


        }

        private void fill_checked_list_with_facts()
        {
            checkedListBox1.Items.Clear();
            foreach (var f in all_facts)
            {
                checkedListBox1.Items.Add(f.Value.Value);
            }
        }

        private void fill_checked_list_with_countries()
        {
            checkedListBox2.Items.Clear();
            foreach (var t in all_terminals)
            {
                checkedListBox2.Items.Add(t.Value.Value);
            }
        }

        private void LoadFacts_Click(object sender, EventArgs e)
        {
            if (all_facts.Count == 0)
            {
                OpenFileDialog ofd = new OpenFileDialog();
                if (ofd.ShowDialog() != DialogResult.OK)
                {
                    return;
                }
                if (!System.IO.File.Exists(ofd.FileName))
                {
                    return;
                }
                get_facts(ofd.FileName);
            }


            pictureBox1.Image = null;
            fill_checked_list_with_facts();
            LoadCountries.Hide();
            checkedListBox2.Hide();
            if(checkedListBox1.Width == 332)
                checkedListBox1.Width = 664;
            RunForward.Show();
        }

        private void LoadCountries_Click(object sender, EventArgs e)
        {
            if (all_terminals.Count == 0)
            {
                OpenFileDialog ofd = new OpenFileDialog();
                if (ofd.ShowDialog() != DialogResult.OK)
                {
                    return;
                }
                if (!System.IO.File.Exists(ofd.FileName))
                {
                    return;
                }
                get_facts(ofd.FileName);
            }

            pictureBox1.Image = null;
            if (!checkedListBox2.Visible)
            {
                checkedListBox2.Show();
                checkedListBox1.Width = 332;
            }
            fill_checked_list_with_facts();
            fill_checked_list_with_countries();
            LoadFacts.Hide();
            RunBackward.Show();
        }



        private Dictionary<double, Terminal> forward_search()
        {
            richTextBox1.Text = "";
            List<string> id_choosen = new List<string>(choosen_facts.Keys);
            int step = 0;
            List<Rule> used_rules = new List<Rule>();
            List<Rule> rules_to_use = rules.Where(r => !id_choosen.Contains(r.Conclusion) && r.Conditions.TrueForAll(s => id_choosen.Contains(s) && !used_rules.Contains(r))).OrderByDescending(r => r.Weight).ToList();

            Dictionary<double, Terminal> res = new Dictionary<double, Terminal>();

            richTextBox1.Text += "Начало прямого поиска \n";
            richTextBox1.Text += "Введенные факты: \n";
            foreach (string s in id_choosen)
                richTextBox1.Text += s + " : " + all_facts[s].Value + "\n";
            while (rules_to_use.Count != 0)
            {
                step++;
                richTextBox1.Text += "\nШаг #" + step + "\n";
                richTextBox1.Text += "--------------------------------------------------------------\n";
                richTextBox1.Text += "Применяемое правило: \n";
                Rule r = rules_to_use.First();
                richTextBox1.Text += r.Id + " : " + r.Conditions.First();
                foreach (string s in r.Conditions)
                {
                    if (s != r.Conditions.First())
                        richTextBox1.Text += ", " + s;
                }
                if (r.Conclusion.Contains('t'))
                {
                    richTextBox1.Text += " -> " + r.Conclusion + " : " + (r.Weight - 1) + "\n";
                }
                else
                {
                    richTextBox1.Text += " -> " + r.Conclusion + " : " + r.Weight + "\n";
                }

                richTextBox1.Text += "--------------------------------------------------------------\n";
                richTextBox1.Text += "Полученный факт: \n";
                if (!id_choosen.Contains(r.Conclusion))
                {
                    id_choosen.Add(r.Conclusion);
                    if (r.Conclusion.Contains("f"))
                    {
                        richTextBox1.Text += r.Conclusion + " : " + all_facts[r.Conclusion].Value + "\n";
                    }
                    else if (r.Conclusion.Contains("n"))
                    {
                        richTextBox1.Text += r.Conclusion + " : " + all_notices[r.Conclusion].Value + "\n";
                    }
                    else
                    {
                        richTextBox1.Text += r.Conclusion + " : " + all_terminals[r.Conclusion].Value + "\n";
                        res[r.Weight] =  all_terminals[r.Conclusion];
                    }
                }
                used_rules.Add(r);

                List<Rule> new_rules = rules.Where(rule => !id_choosen.Contains(rule.Conclusion) && rule.Conditions.TrueForAll(s => id_choosen.Contains(s))).OrderByDescending(rule => rule.Weight).ToList();
                rules_to_use.Clear();
                foreach (Rule rule in new_rules)
                {
                    if (!used_rules.Contains(rule))
                    {
                        rules_to_use.Add(rule);
                    }
                }
            }
            return res;
        }

        private List<Fact> backward_search()
        {
            richTextBox1.Text = "";
            List<string> id_choosen = new List<string>();
            List<Fact> res = new List<Fact>();
            id_choosen.Add(choosen_terminal);
            List<Fact> used_notices = new List<Fact>();

            int step = 0;
            richTextBox1.Text += "Начало обратного поиска \n";
            richTextBox1.Text += "Выбранный терминал: \n";
            richTextBox1.Text += choosen_terminal + " : " + all_terminals[choosen_terminal].Value + "\n";
            while (id_choosen.Count != 0)
            {
                step++;
                richTextBox1.Text += "\nШаг #" + step + "\n";
                richTextBox1.Text += "--------------------------------------------------------------\n";
                richTextBox1.Text += "Применяемое правило: \n";

                string id_to_search = id_choosen.First();
                id_choosen.Remove(id_to_search);

                foreach (Rule r in rules)
                {
                    if (r.Conclusion == id_to_search)
                    {
                        if (r.Conditions.Any(s => s.Contains('f')) && !r.Conditions.Where(s => s.Contains('f')).ToList().TrueForAll(s => choosen_facts.Keys.Contains(s)))
                            continue;
                        richTextBox1.Text += r.Id + " : " + r.Conditions.First();
                        foreach (string s in r.Conditions)
                        {
                            if (s != r.Conditions.First())
                                richTextBox1.Text += ", " + s;
                        }
                        richTextBox1.Text += " -> " + r.Conclusion + "\n";
                        richTextBox1.Text += "--------------------------------------------------------------\n";
                        richTextBox1.Text += "Полученные факты: \n";
                        foreach (string s in r.Conditions)
                        {
                            if (s[0] == 'f' && !res.Contains(all_facts[s]))
                            {
                                res.Add(all_facts[s]);
                                richTextBox1.Text += s + " : " + all_facts[s].Value + "\n";
                            }
                            else if (s[0] == 'n' && !used_notices.Contains(all_notices[s]))
                            {
                                used_notices.Add(all_notices[s]);
                                id_choosen.Add(s);
                            }
                        }
                    }
                }

            }
            return res;
        }

        private void RunForward_Click(object sender, EventArgs e)
        {
            pictureBox1.Image = null;
            choosen_facts.Clear();
            foreach(string s in checkedListBox1.CheckedItems)
            {
                foreach(var f in all_facts)
                {
                    if (f.Value.Value == s)
                    {
                        choosen_facts[f.Key] = f.Value;
                        choosen_facts[f.Key].Weight = 1;
                    }
                }
            }

            foreach (Rule r in rules)
            {
                double minimum = 1;
                foreach(string s in r.Conditions)
                {
                    if (s.Contains('f') && !choosen_facts.Values.Contains(all_facts[s]))
                        minimum = 0;

                    if (s.Contains('n') && all_notices[s].Weight < minimum)
                        minimum = all_notices[s].Weight;
                }

                r.Weight = minimum;
                if (r.Conclusion.Contains('t'))
                    r.Weight = r.Weight + 1;
            }

            Dictionary<double, Terminal> res = forward_search();
            if (res.Count != 0)
            {
                double maximum = res.Keys.Max();
                pictureBox1.Image = new Bitmap(res[maximum].Img);
            }

            choosen_facts.Clear();
        }



        private void RunBackward_Click(object sender, EventArgs e)
        {
            pictureBox1.Image = null;
            choosen_facts.Clear();
            foreach (string s in checkedListBox1.CheckedItems)
            {
                foreach (var f in all_facts)
                {
                    if (f.Value.Value == s)
                    {
                        choosen_facts[f.Key] = f.Value;
                    }
                }
            }

            foreach (string s in checkedListBox2.CheckedItems)
            {
                foreach (var t in all_terminals)
                {
                    if (t.Value.Value == s)
                    {
                        choosen_terminal = t.Key;
                        break;
                    }
                }
            }

            List<Fact> res = backward_search();
            richTextBox1.Text += "--------------------------------------------------------------\n";
            richTextBox1.Text += "\nФакты из которых можно получить искомый терминал: \n";

            foreach (Fact f in res)
            {
                if (f.Id.Contains('f'))
                    richTextBox1.Text += f.Id + " : " + f.Value + "\n";
            }
            richTextBox1.Text += "\nВыбранные факты: \n";
            foreach (Fact f in choosen_facts.Values)
            {
                richTextBox1.Text += f.Id + " : " + f.Value + "\n";
            }

            if (res.TrueForAll(r => choosen_facts.Values.Contains(r)) && res.Count != 0)
            {
                richTextBox1.Text += "\nТерминал выводим в данной системе из этих фактов \n";
            }
            else
            {
                richTextBox1.Text += "\nТерминал не выводим в данной системе из этих фактов \n";
            }
            pictureBox1.Image = new Bitmap(all_terminals[choosen_terminal].Img);

        }

        private void ClearButton_Click(object sender, EventArgs e)
        {
            LoadFacts.Show();
            LoadCountries.Show();
            RunBackward.Hide();
            RunForward.Hide();
            checkedListBox2.Hide();
            checkedListBox1.Width = checkedListBox2.Width * 2;
            checkedListBox1.Items.Clear();
            checkedListBox2.Items.Clear();
            pictureBox1.Image = null;
            richTextBox1.Text = "";
        }

        private void checkedListBox2_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            var list = sender as CheckedListBox;
            if (e.NewValue == CheckState.Checked && RunBackward.Visible)
                foreach (int index in list.CheckedIndices)
                    if (index != e.Index)
                        list.SetItemChecked(index, false);
        }
    }
}
