<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="WebApplication1.LoginPage" %>

<!DOCTYPE html>
<link href="Login.css?v=1" rel="stylesheet" type="text/css" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
    /* General Styles */
    body {
        font-family: 'Poppins', sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        overflow: hidden;
        background: linear-gradient(135deg, #4e54c8, #8f94fb);
    }

    .container {
        width: 500px;
        height: 300px;
        padding: 2rem;
        text-align: center;
        background: rgba(255, 255, 255, 0.1);

        backdrop-filter: blur(15px);
        border-radius: 20px;
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
        /*animation: fadeIn 1.5s ease-in-out;*/
        position: relative; /* Important to create a stacking context */
        transform: translateX(-95px);
        transform: translateY(-21.66666667px);
    z-index: 1;
    }

    .container h2 {
        color: #fff;
        font-size: 2.5rem;
        margin-bottom: 1rem;
        background: -webkit-linear-gradient(#ffffff, #b1b2ff);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;

    }

    .btn {
        display: inline-block;
        margin: 10px;
        padding: 15px 30px;
        font-size: 1.2rem;
        text-transform: uppercase;
        border: none;
        border-radius: 30px;
        transition: all 0.3s ease;
        cursor: pointer;
        color: white;
        transform: translateX(-10.6666667px);


    }

    .btn:hover {
        transform: translateX(-10.6666667px) translateY(-3px);
       
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }

    .admin-btn {
        background: linear-gradient(135deg, #ff7e5f, #feb47b);
    }

    .customer-btn {
        background: linear-gradient(135deg, #6a11cb, #2575fc);
    }



    @keyframes fadeIn {
        0% {
            opacity: 0;
            transform: translateY(50px);
        }
        100% {
            opacity: 1;
            transform: translateY(0);
        }
    }

    #particles-js {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    z-index: 0;
}

</style>

</head>
<body>
    <div id="particles-js"></div>
    <form id="form1" runat="server">
         <div class="container">
    <h2>Login</h2>
    <button type="submit" class="btn admin-btn" onclick="admin">Admin</button>
    <button type="submit" class="btn customer-btn" onclick="customer">Customer</button>
</div>

    </form>
    <script src="js/particles.min.js"></script>
    <script>
    particlesJS('particles-js', {
        "particles": {
            "number": {
                "value": 100,
                "density": { "enable": true, "value_area": 800 }
            },
            "color": { "value": "#ffffff" },
            "shape": {
                "type": "circle",
                "stroke": { "width": 0, "color": "#000000" }
            },
            "opacity": { "value": 0.5, "random": false },
            "size": { "value": 3, "random": true },
            "line_linked": {
                "enable": true,
                "distance": 150,
                "color": "#ffffff",
                "opacity": 0.4,
                "width": 1
            },
            "move": {
                "enable": true,
                "speed": 3,
                "direction": "none",
                "random": false,
                "straight": false,
                "out_mode": "out",
                "bounce": false
            }
        },
        "interactivity": {
            "events": {
                "onhover": {
                    "enable": true,
                    "mode": "repulse"
                },
                "onclick": {
                    "enable": true,
                    "mode": "push"
                }
            },
            "modes": {
                "repulse": {
                    "distance": 100,
                    "duration": 0.4
                },
                "push": {
                    "particles_nb": 4
                }
            }
        }
,
        "retina_detect": true
    });
    </script>

</body>
</html>
