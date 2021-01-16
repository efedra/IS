namespace ProductionSystem
{
    partial class Form1
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.checkedListBox1 = new System.Windows.Forms.CheckedListBox();
            this.LoadFacts = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.RunForward = new System.Windows.Forms.Button();
            this.richTextBox1 = new System.Windows.Forms.RichTextBox();
            this.LoadCountries = new System.Windows.Forms.Button();
            this.RunBackward = new System.Windows.Forms.Button();
            this.ClearButton = new System.Windows.Forms.Button();
            this.checkedListBox2 = new System.Windows.Forms.CheckedListBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // pictureBox1
            // 
            this.pictureBox1.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.pictureBox1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pictureBox1.Location = new System.Drawing.Point(12, 12);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(566, 361);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            // 
            // checkedListBox1
            // 
            this.checkedListBox1.FormattingEnabled = true;
            this.checkedListBox1.Location = new System.Drawing.Point(584, 12);
            this.checkedListBox1.Name = "checkedListBox1";
            this.checkedListBox1.Size = new System.Drawing.Size(332, 364);
            this.checkedListBox1.TabIndex = 2;
            // 
            // LoadFacts
            // 
            this.LoadFacts.Location = new System.Drawing.Point(12, 379);
            this.LoadFacts.Name = "LoadFacts";
            this.LoadFacts.Size = new System.Drawing.Size(177, 79);
            this.LoadFacts.TabIndex = 3;
            this.LoadFacts.Text = "Load Facts";
            this.LoadFacts.UseVisualStyleBackColor = true;
            this.LoadFacts.Click += new System.EventHandler(this.LoadFacts_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // RunForward
            // 
            this.RunForward.Location = new System.Drawing.Point(12, 464);
            this.RunForward.Name = "RunForward";
            this.RunForward.Size = new System.Drawing.Size(177, 88);
            this.RunForward.TabIndex = 4;
            this.RunForward.Text = "Run forward search";
            this.RunForward.UseVisualStyleBackColor = true;
            this.RunForward.Click += new System.EventHandler(this.RunForward_Click);
            // 
            // richTextBox1
            // 
            this.richTextBox1.Location = new System.Drawing.Point(584, 379);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new System.Drawing.Size(668, 273);
            this.richTextBox1.TabIndex = 5;
            this.richTextBox1.Text = "";
            // 
            // LoadCountries
            // 
            this.LoadCountries.Location = new System.Drawing.Point(195, 379);
            this.LoadCountries.Name = "LoadCountries";
            this.LoadCountries.Size = new System.Drawing.Size(177, 79);
            this.LoadCountries.TabIndex = 6;
            this.LoadCountries.Text = "Load Countries";
            this.LoadCountries.UseVisualStyleBackColor = true;
            this.LoadCountries.Click += new System.EventHandler(this.LoadCountries_Click);
            // 
            // RunBackward
            // 
            this.RunBackward.Location = new System.Drawing.Point(195, 464);
            this.RunBackward.Name = "RunBackward";
            this.RunBackward.Size = new System.Drawing.Size(177, 88);
            this.RunBackward.TabIndex = 7;
            this.RunBackward.Text = "Run backward search";
            this.RunBackward.UseVisualStyleBackColor = true;
            this.RunBackward.Click += new System.EventHandler(this.RunBackward_Click);
            // 
            // ClearButton
            // 
            this.ClearButton.Location = new System.Drawing.Point(378, 379);
            this.ClearButton.Name = "ClearButton";
            this.ClearButton.Size = new System.Drawing.Size(177, 79);
            this.ClearButton.TabIndex = 8;
            this.ClearButton.Text = "Clear";
            this.ClearButton.UseVisualStyleBackColor = true;
            this.ClearButton.Click += new System.EventHandler(this.ClearButton_Click);
            // 
            // checkedListBox2
            // 
            this.checkedListBox2.FormattingEnabled = true;
            this.checkedListBox2.Location = new System.Drawing.Point(922, 9);
            this.checkedListBox2.Name = "checkedListBox2";
            this.checkedListBox2.Size = new System.Drawing.Size(332, 364);
            this.checkedListBox2.TabIndex = 9;
            this.checkedListBox2.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.checkedListBox2_ItemCheck);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(13F, 27F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1258, 664);
            this.Controls.Add(this.checkedListBox2);
            this.Controls.Add(this.ClearButton);
            this.Controls.Add(this.RunBackward);
            this.Controls.Add(this.LoadCountries);
            this.Controls.Add(this.richTextBox1);
            this.Controls.Add(this.RunForward);
            this.Controls.Add(this.LoadFacts);
            this.Controls.Add(this.checkedListBox1);
            this.Controls.Add(this.pictureBox1);
            this.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "Production System";
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.CheckedListBox checkedListBox1;
        private System.Windows.Forms.Button LoadFacts;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Button RunForward;
        private System.Windows.Forms.RichTextBox richTextBox1;
        private System.Windows.Forms.Button LoadCountries;
        private System.Windows.Forms.Button RunBackward;
        private System.Windows.Forms.Button ClearButton;
        private System.Windows.Forms.CheckedListBox checkedListBox2;
    }
}

