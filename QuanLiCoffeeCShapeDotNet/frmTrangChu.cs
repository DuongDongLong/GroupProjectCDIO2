﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuanLiCoffeeCShapeDotNet.DAO;
using QuanLiCoffeeCShapeDotNet.DTO;

namespace QuanLiCoffeeCShapeDotNet
{
    public partial class frmTrangChu : Form
    {

		Form frmMatHang;
		Form frmThanhToan;
        public frmTrangChu()
        {
            InitializeComponent();
        }

		public Boolean CheckForm(string frm)
		{
			foreach (Form f in this.MdiChildren)
			{
				if (f.Name.Equals(frm))
				{
					return true;
				}

			}
			return false;
		}

		private void toolStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

		private void tbtnQLBanHang_Click(object sender, EventArgs e)
		{
			frmMatHang = new frmDanhMucMatHang();
			frmMatHang.ShowDialog();
		}

		private void btnThanhToan_Click(object sender, EventArgs e)
		{
			frmThanhToan = new frmPayment();
			frmThanhToan.ShowDialog();
		}

		private void tBtnThoat_Click(object sender, EventArgs e)
		{
			Application.Exit();
		}

		private void frmTrangChu_Load(object sender, EventArgs e)
		{
			loadKhuVuc();
			loadTreeViewFood();
		}

		private void loadKhuVuc()
		{
			List<KhuVuc> list = KhuVucDAO.Instances.loadKhuVuc();
			for (int i = 0; i < list.Count; i++)
			{
				TabPage tab = new TabPage
				{
					AutoScroll = true,
				};
				tab.UseVisualStyleBackColor = true;
				tab.Text = list[i].KhuVucName;

				//Add ban vao tab
				List<Table> listTable = TableDAO.Instances.loadTableByIdKhuVuc(list[i].IdKhuVuc);
				Button btnBegin = new Button
				{
					Width = 0,
					Height = 0,
					Location = new Point(0, 0)
				};
				for (int j = 0; j < listTable.Count; j++)
				{
					Button btn = new Button
					{
						//Text = listTable[j].TableName + Environment.NewLine +
						//listTable[j].TableStatus,
						Text = listTable[j].TableName,
						Width = 128,
						Height = 150,

						TextAlign = ContentAlignment.BottomCenter,
						ImageAlign = ContentAlignment.TopCenter,
						TextImageRelation = TextImageRelation.Overlay,

						Location = new Point(btnBegin.Location.X + btnBegin.Width,
						btnBegin.Location.Y),
						

					};
					btn.Click += btnClick;
					switch (listTable[j].TableStatus)
					{
						case 1:
							{
								btn.Image = global::QuanLiCoffeeCShapeDotNet.Properties.Resources.coffe;
								break;
							}
						default:
							{
								btn.Image = global::QuanLiCoffeeCShapeDotNet.Properties.Resources.coffeNull;
								break;
							}
					}

					tab.Controls.Add(btn);

					btnBegin = btn;
					if (j % 3 == 0 && j != 0)
					{
						btnBegin.Location = new Point(0, btnBegin.Location.Y + btnBegin.Height);

					}


				}

				tabControlKhuVuc.Controls.Add(tab);
			}
		}

		private void btnClick(object sender, EventArgs e)
		{
			Button btn = sender as Button;

			MessageBox.Show(btn.Text);
		}

		public void loadTreeViewFood()
		{
			List<CategoryFood> listCFood = CategoryFoodDAO.Instances.loadCategory();
			twFood.Nodes.Add("Tất cả");
			for (int i = 0; i < listCFood.Count; i++)
			{
				//twFood.Nodes.Add(listCFood[i].CategoryName);
				twFood.Nodes[0].Nodes.Add(listCFood[i].CategoryName);
				//twFood.Nodes[i].Tag = "1";

				List<Food> listFood = FoodDAO.Instances.loadFoodByIdCategoryFood(listCFood[i].IdCategory);

				for (int j = 0; j <listFood.Count; j++)
				{
					twFood.Nodes[0].Nodes[i].Nodes.Add(listFood[j].FoodName);
				}
			}
		}

        private void tabControlKhuVuc_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
