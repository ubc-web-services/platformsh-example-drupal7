<?php

use Drupal\Component\Utility\Random;
use Drupal\DrupalExtension\Context\DrupalContext;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Drupal\DrupalExtension\Event\EntityEvent;
use Behat\Behat\Context\BehatContext;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Behat\Context\Step;
use Behat\Behat\Context\Step\Given;
use Behat\Behat\Context\TranslatableContext;
use Behat\Behat\Tester\Exception\PendingException;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\Mink\Element\Element;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends RawDrupalContext implements SnippetAcceptingContext, TranslatableContext {

  /**
   * Directory path where the screenshots are collected.
   *
   * @var string
   */
  protected $screenshot_dir = '/tmp';

  /**
   * Keep track of drush output.
   *
   * @var string|boolean
   */
  protected $drush_output;
  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct($parameters) {
    if (isset($parameters['screenshot_dir'])) {
      $this->screenshot_dir = $parameters['screenshot_dir'];
    }
  }
  /**
   * Returns list of definition translation resources paths.
   *
   * @return array
   */
  public static function getTranslationResources()
  {
    return glob(__DIR__ . '/../../../../i18n/*.xliff');
  }
	/**
	 * Take screenshot when step fails. Works only with Selenium2Driver.
	 * Screenshot is saved at [Date]/[Feature]/[Scenario]/[Step].jpg
	 *
	 * @AfterStep
	 */
	public function after(Behat\Behat\Hook\Scope\AfterStepScope $scope) {
		if ($scope->getTestResult()->getResultCode() === 99) {
			$driver = $this->getSession()->getDriver();
			if ($driver instanceof Behat\Mink\Driver\Selenium2Driver) {
				$fileName = date('Y-m-d \a\t h.i.s') . '.png';
				$this->saveScreenshot($fileName, $this->screenshot_dir);
				print 'Screenshot at: '.$this->screenshot_dir.'/' . $fileName;
			}
		}
	}

  /**
   * @throw Exception when the condition is not met
   */
  private function assert($condition, $message) {
    if ($condition) {
      return;
    }
    throw new \Exception($message);
  }
  /**
   * @Then I must be on :arg1
   */
  public function iMustBeOn($arg1)
  {
    $cleaned = $this->getCleanURL($this->getSession()->getCurrentUrl());
    if ($this->endsWith($arg1, "=")) {
    	$arg1 = $arg1 . urlencode($this->getMinkParameter('base_url'));
    }
    $this->assert($cleaned == $arg1, $cleaned . "!=" . $arg1);
  }
  /**
   * @Then I must not be on :arg1
   */
  public function iMustNotBeOn($arg1)
  {
    $cleaned = $this->getCleanURL($this->getSession()->getCurrentUrl());
    if ($this->endsWith($arg1, "=")) {
    	$arg1 = $arg1 . urlencode($this->getMinkParameter('base_url'));
    }
    $this->assert($cleaned != $arg1, $cleaned . "==" . $arg1);
  }

  /**
   * Returns a clean URL
   */
  private function getCleanURL($url)
  {
  	$pound = explode("#", $url);
  	$prsed = $url;
  	if (sizeof($pound) > 1) {
  		$prsed = implode("", array_slice($pound, 0, sizeof($pound) - 1));
  	}
    return $this->endsWith($prsed, "/")? substr($prsed, 0, strlen($prsed) - 1) : $prsed;
  }
  /**
   * Returns true if str1 ends with str2
   */
  private function endsWith($str1, $str2)
  {
    return $str2 === '' || substr_compare($str1, $str2, -strlen($str2)) === 0;
  }
  /**
	 * @When I wait for :arg1
	 */
  public function iWaitFor($arg1)
  {
    $this->getSession()->wait($arg1);
  }
  /**
	 * @Given I run drush temporarily for :command
	 */
  public function assertDrushCommand($command)
  {
    try {
      $this->drush_output = $this->getDriver('drush')->$command();
    } catch (Exception $e) {
      throw new \Exception('Invalid drush command');
    }
  }
  /**
	 * @Then drush output should match temporarily for :regex
	 */
  public function assertDrushOutputMatches($regex)
  {
    if (!isset($this->drush_output) || !preg_match($regex, (string) $this->drush_output)) {
        throw new \Exception(sprintf("The pattern %s was not found anywhere in the drush output.\nOutput:\n\n%s", $regex, $this->drush_output));
    }
  }
  /**
 	 * @Then I save drush output
	 */
  public function saveDrushOutput() {
    $file = fopen("cron.txt", "a") or die("Unable to open file.");
    fwrite($file, $this->drush_output);
    fclose($file);
  }
  /**
	 * Clicks link with specified id|title|alt|text
	 * Example: When I follow "Log In" in the "#form"
	 *
	 * @When /^(?:|I )follow "(?P<link>(?:[^"]|\\")*)" in the "(?P<region>(?:[^"]|\\")*)"$/
	 */
	public function clickLinkInTheRegion($link, $region)
	{
			$link = $this->fixStepArgument($link);
			$element = $this->getSession()->getPage()->find("css", $region);
			$this->assert(isset($element), "Element not found");
			$element->clickLink($link);
	}
  /**
	 * Returns fixed step argument (with \\" replaced back to ")
	 *
	 * @param string $argument
	 *
	 * @return string
	 */
	protected function fixStepArgument($argument)
	{
			return str_replace('\\"', '"', $argument);
	}
}
