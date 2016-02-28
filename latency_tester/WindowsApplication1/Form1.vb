Public Class Form1
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load

    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Dim graph As Graphics = Me.CreateGraphics
        Dim mypen2 As SolidBrush = New SolidBrush(Color.Black)

        Dim t As Single
        Dim len As Single
        Dim leftstart As Single
        Const interval As Single = 150
        len = PictureBox2.Left - PictureBox1.Left - PictureBox1.Width
        leftstart = PictureBox1.Left + PictureBox1.Width
        Dim tstart As Double = My.Computer.Clock.TickCount()
        While True
            t = My.Computer.Clock.TickCount()
            Dim lpos As Single
            lpos = leftstart + len * ((t - tstart) Mod interval) / interval
            graph.Clear(Me.BackColor)
            graph.FillRectangle(mypen2, lpos, 30, 90, 150)
            'My.Application.DoEvents()
            System.Threading.Thread.Sleep(3)
        End While
    End Sub

    Private Sub PictureBox3_Click(sender As Object, e As EventArgs)

    End Sub
End Class
