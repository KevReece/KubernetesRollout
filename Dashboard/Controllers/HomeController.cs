using Microsoft.AspNetCore.Mvc;

namespace Dashboard.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        var colourUrl = Environment.GetEnvironmentVariable("COLOUR_URL");
        if (string.IsNullOrEmpty(colourUrl))
        {
            throw new Exception("COLOUR_URL environment variable not set");
        }
        return View(new {ColourUrl = colourUrl});
    }
}
